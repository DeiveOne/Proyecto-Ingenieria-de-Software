import "./Input.css";

export default function Input({
  label,

  placeholder,

  type = "text",

  required = false,

  value,

  onChange,

  error,

  readOnly = false,

  disabled = false,
}) {
  return (
    <div className="inputGroup">
      <label>
        {label}

        {required && <span>*</span>}
      </label>

      <input
        type={type}
        placeholder={placeholder}
        value={value}
        onChange={onChange}
        readOnly={readOnly}
        disabled={disabled}
      />

      {error && <p className="inputError">{error}</p>}
    </div>
  );
}
